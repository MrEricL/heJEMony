public interface Deque<T> {

    void addLast(T val);

    T peekLast();

    T pollFirst();

    T pollLast();

    T peekFirst();

    boolean isEmpty();

    int size();

    boolean contains(T val);


}
