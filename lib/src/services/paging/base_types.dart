class PagingData<T> {
  const PagingData(this.items);

  factory PagingData.empty() => PagingData<T>([]);

  final List<T> items;

  int get length => items.length;

  T operator [](int index) => items[index];

  void operator []=(int index, T value) => items[index] = value;
}

void test() {}
