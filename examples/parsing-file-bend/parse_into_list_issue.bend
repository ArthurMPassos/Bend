
#Example of f

# Bytes/split_once xs cond = (Bytes/split_once.go xs cond @x x)
#   Bytes/split_once.go  List/Nil        cond acc = (Result/Err (acc List/Nil))
#   Bytes/split_once.go (List/Cons x xs) cond acc =
#     if (== cond x) {
#       (Result/Ok ((acc List/Nil), xs))
#     } else {
#       (Bytes/split_once.go xs cond @y (acc (List/Cons x y)))
#     }


def IO/FS/read_line_my(fd):
  return IO/FS/read_line.read_chunks_my(fd, [])

def IO/FS/read_line.read_chunks_my(fd, chunks):
  with IO:
    # Read line in 1kB chunks
    chunk <- IO/FS/read(fd, 1024)
    match res = Bytes/split_once(chunk, '\n'):
      case Result/Ok:
        (line, rest) = res.val
        (length, *) = List/length(rest)
        * <- IO/FS/seek(fd, to_i24(length) * -1, IO/FS/SEEK_CUR)
        chunks = List/Cons(line, chunks)
        bytes = List/flatten(chunks)
        return wrap(bytes)
      case Result/Err:
        line = res.val
        chunks = List/Cons(line, chunks)
        return IO/FS/read_line.read_chunks(fd, chunks)


def main:
  with IO:
    fd <- IO/FS/open("../datasets/sequence_value_issue.txt", "r")

    bytes <- IO/FS/read_line(fd)
    bytes <- IO/FS/read_line(fd)
    bytes <- IO/FS/read_line(fd)

    txt = Bytes/decode_utf8(bytes)
    return txt

