# Flutter Matrix  

---
<div style="text-align: center;">
    <a href="https://github.com/PythonnotJava/flutter_matrix">
        <img src="flutter_matrix/docs/design.png" alt="" style="border-radius: 20px; display: block;"/>
    </a>
</div>

## 💡What's the Flutter Matrix?

<p style="text-indent: 2em">
The matrix class designed for Flutter can also be used in pure Dart, 
and is also a full-platform alternative to the Matply library. 
It supports basic matrix operations, linear algebra, probability
theory and mathematical statistics, geometric simulation, central difference, etc.
</p>

## 📄Need a local document?
<p style="text-indent: 2em">
Flutter Matrix provides a local docs (by markdown) folder and a building module based on mkdocs. If you have Python on your environment, switch to the same directory as the mkdocs.yml file and run the following command.
</p>

```text
pip install mkdocs mkdocs-material pymdown-extensions mkdocs-material-extensions
```
<p style="text-indent: 2em">
After successfully installing the above libraries, run the following command again. You will find that you have generated a folder named site. Open the index.html in the folder to browse the online web documents.

</p>

```
mkdocs build
```

<p style="text-indent: 2em">
I also provide online documents: <a href="https://www.robot-shadow.cn/src/pkg/Flutter_Matrix/site/">👉Click Me!👈</a>

</p>

## 🛎️Attention.
- Flutter Matrix can run in a pure Dart environment.

## ✍️Example
- Use `arrange` to generate a data matrix with evenly spaced intervals.
```dart
import 'package:flutter_matrix/matrix_type.dart';

main() {
  data_format = "%2.1f";
  var mt = Matrix.linspace(
      start: 0,
      end: 10, 
      row: 10, 
      column: 10, 
      keep: true
  );
  mt.visible();
}
```
- Output.
```text
[
 [ 0.0  0.1  0.2  0.3  0.4  0.5  0.6  0.7  0.8  0.9]
 [ 1.0  1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9]
 [ 2.0  2.1  2.2  2.3  2.4  2.5  2.6  2.7  2.8  2.9]
 [ 3.0  3.1  3.2  3.3  3.4  3.5  3.6  3.7  3.8  3.9]
 [ 4.0  4.1  4.2  4.3  4.4  4.5  4.6  4.7  4.8  4.9]
 [ 5.1  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9  6.0]
 [ 6.1  6.2  6.3  6.4  6.5  6.6  6.7  6.8  6.9  7.0]
 [ 7.1  7.2  7.3  7.4  7.5  7.6  7.7  7.8  7.9  8.0]
 [ 8.1  8.2  8.3  8.4  8.5  8.6  8.7  8.8  8.9  9.0]
 [ 9.1  9.2  9.3  9.4  9.5  9.6  9.7  9.8  9.9 10.0]
]
```
