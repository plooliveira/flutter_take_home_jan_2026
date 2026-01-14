# aurora_take_home_paulo

Completed on January 13, 2026

**Duration**
- **10 min** – Initial setup (including the decision to use Material utilities)  
- **35 min** – Research on the discontinuation of `palette_generator` for better context (GitHub issues, blog post, and code snippets using Material utilities)  
- **2 hours** – Implementation  
- **A few minutes** – Short breaks for coffee since it was late at night 🙃

---

### Initial comments

I decided to complete the assessment as quickly as possible, since I had already read the requirements and did not want to spend too much time thinking about it, given that the idea of the exercise was to work under a tighter time constraint. I treated the project as a POC or prototype to validate a performant and reliable approach to dealing with the problem, intentionally leaving out certain aspects.

---

### What I would do differently if I had 20 hours to do it

**Refactoring**
The most problematic part of my implementation is the duplication of cached image requests with `CachedNetworkImageProvider` and `CachedNetworkImage`. To instantiate it only once and reuse it for both `getColorsFromImage` and on the screen, I would need to ditch `CachedNetworkImage` and use a regular `Image` widget, which would significantly increase the complexity of doing a smooth transition between images. Given the time constraints, I accepted this as a trade-off to keep transitions simple.

**State management**
I chose the **Ctrl** package for practical reasons. It allowed me to move faster under the given time constraints while still keeping state and side effects explicit. For example, when I read *“Respect light/dark mode,”* I automatically knew how to handle it. That being said, if I had significantly more time, I would prefer to use **Bloc** to have more control over the way events and states happen. Fine control over event concurrency would be helpful to implement prefetching of the next image (more below).

**Business logic**
I would move the logic inside `getNewImage` from the Ctrl class to a separate layer. Personally, I like to have a **Logic layer** rather than a Domain layer and use the **Action pattern** (from Laravel) instead of use cases. I would love to explain why another time.

**Better abstractions**

**Loading widget.**  
Initially, I had a `BackdropFilter` together with my `CircularProgressIndicator` widget to have a better loading feel. However, `BackdropFilter` is relatively expensive performance-wise, so in my last commit I removed it to reduce UI cost. Since I did not want to spend more time on it, I left just the progress indicator. A more refined loading state would definitely be an improvement.

**Prefetching the next image.**  
This would be a great improvement for smoother usage of the app. If the app had a requirement to go back and view previously loaded images, I would also cache the extracted color palettes. Handling errors while prefetching the next image would require careful consideration.

**Error handling.**  
I implemented basic error handling, which is sufficient for this version, but it could be made more comprehensive.

**Animations.**  
I chose to use `flutter_animate` because it provides expressive animations with minimal boilerplate. Unfortunately, I did not have time to implement fade transitions for the background and other refinements.

**Theme.**  
I implemented a very rudimentary theme selection to demonstrate how color choices behave in different environments. With more time, I would implement a more robust theming approach.

**Accessibility.**  
At minimum, I would add `Semantics` labels to the main action button and loading states to support screen readers.

---

### Color selection for a dynamic background

This was an interesting part of the assignment. My initial thought was to use the dominant color with the `palette_generator` package that I was already familiar with. However, after reading the requirements, I realized that this approach would complicate handling light and dark modes, and that `palette_generator` had been discontinued.

I considered using the community-maintained version or similar packages, but after reading the open issue explaining that the Flutter team will no longer support `palette_generator`, I discovered that Material Design now provides a **utilities package** for this type of color extraction, albeit with more manual work required.

After digging deeper, I also understood the reasons behind the discontinuation of `palette_generator`: it can cause UI lock issues since it runs on the main thread, and it is based on an older Android color palette API that does not align well with modern Material Design principles.

I therefore took a code snippet implementing color extraction using `material_color_utilities` and modified it to isolate the quantization logic in a separate thread.

And voilà.

Links:
- https://github.com/flutter/flutter/issues/122788
- https://jwill.dev/blog/2025/06/02/Extract-Colors-From-Image.html
- https://github.com/jwill/extract_palette_from_image/blob/main/lib/image.dart
