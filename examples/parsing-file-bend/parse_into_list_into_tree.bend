# Parses a file into a list of integers with 
# the first line being the size of the dataset
# (the last empty line is important)
# Example:
#4
#41
#32
#17
#23
#

# converts a string to an integer
def CharToInt(char):
  return char - 48

def strLen(l):
  match l:
    case String/Nil: 
      return 0
    case String/Cons: 
      return strLen(l.tail) + 1

def pow(value, power):
  if power == 0:
    return 1
  else:
    return value * pow(value, power - 1)
    
def StringToInt(str):
  lenght = strLen(str)
  return _StringToInt(str, lenght)


def _StringToInt(str, acc):
  fold str with acc:
    case String/Cons:
      return CharToInt(str.head )*pow(10, acc - 1) + str.tail(acc - 1)
    case String/Nil:
      return 0

def parse_list(txt):
  match txt:
    case String/Cons: 
      (head, tail) = txt
      res = List/Cons { head: StringToInt(head), tail: parse_list(tail) }
    case String/Nil:
      res = List/Nil
  return res

def get_dataset():
  with IO:
    fd <- IO/FS/open("../datasets/sequence_random.txt", "r")

    bytes <- IO/FS/read_to_end(fd)

    match res = Bytes/split_once(bytes, '\n'):
      case Result/Ok:
        (firstLine, rest) = res.val
        sizeAndList = (StringToInt(Bytes/decode_utf8(firstLine)), rest)
      case Result/Err:
        sizeAndList = (0, [])
    
    (sizeBytes, rest) = sizeAndList
    # first line has size of the dataset
    full_size = StringToInt(Bytes/decode_utf8(sizeBytes))
    bend size = full_size, bytes = rest: 
      when size > 0:
        match res = Bytes/split_once(bytes, '\n'):
          case Result/Ok:
            (line, rest) = res.val
            value = StringToInt(Bytes/decode_utf8(line))
            list = List/Cons { head: value, tail: fork(size - 1, rest) }
          case Result/Err:
            value = 0
            list = List/Nil
      else:
        list = List/Nil
    return (list)


append = @l @e
  (concat l (List/Cons e List/Nil))

concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (concat l1.tail l2))
    List/Nil: l2
  }

split = @l @i (split.aux [] l i)

split.aux = @acc @l @i
  match l {
    List/Cons: 
      switch i {
        0: (acc, l)
        _: (split.aux (append acc l.head) l.tail i-1)
      }
    List/Nil: *
  }

len = @l
  match l {
    List/Nil: 0
    List/Cons: (+ 1 (len l.tail))
  }


def bi_list_to_tuple(l):
  match l:
    case List/Cons: 
      match l.tail:
        case List/Cons:
          return (l.head, l.tail.head)
        case List/Nil:
          return (l.head, *)
    case List/Nil: 
      return List/Nil

def main:
  with IO:
    fd <- IO/FS/open("../datasets/lines_sorted.txt", "r")

    bytes <- IO/FS/read_to_end(fd)

    match res = Bytes/split_once(bytes, '\n'):
      case Result/Ok:
        (firstLine, rest) = res.val
        sizeAndList = (StringToInt(Bytes/decode_utf8(firstLine)), rest)
      case Result/Err:
        sizeAndList = (0, [])
    
    (sizeBytes, rest) = sizeAndList
    # first line has size of the dataset
    full_size = StringToInt(Bytes/decode_utf8(sizeBytes))
    bend size = full_size, bytes = rest: 
      when size > 0:
        match res = Bytes/split_once(bytes, '\n'):
          case Result/Ok:
            (line, rest) = res.val
            value = StringToInt(Bytes/decode_utf8(line))
            list = List/Cons { head: value, tail: fork(size - 1, rest) }
          case Result/Err:
            value = 0
            list = List/Nil
      else:
        list = List/Nil

    # make tree of tuples:  
    bend depth = to_u24(log(to_f24(full_size), 2.0)), size = full_size , list = list:
      when depth > 1:
        (left, right) = split(list, size / 2)
        left_tree = fork(depth - 1, size / 2, left)
        right_tree = fork(depth - 1, size / 2, right)
        tree = (left_tree, right_tree)
      else:
        tree = bi_list_to_tuple(list)
    
    return tree

