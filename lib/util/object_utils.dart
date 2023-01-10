extension Optional<T extends Object> on T? {
  V? apply<V>(V Function(T) func) {
    return this != null ? func(this!) : null;
  }
}
