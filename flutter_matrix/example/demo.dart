class Person {
  final String name;
  final int age;
  Person(this.name, this.age);
}

main(){
  var person = Person('Diana', 32);
  var Person(:name, :age) = person;
  print('$name, $age'); // 输出: Diana, 32
}