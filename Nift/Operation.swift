public enum Operation {
    case add(mount: Any)
    case remove(mount: Any)
    case reorder(mount: Any, index: Int)
    case replace(old: Any, new: Any)
}
