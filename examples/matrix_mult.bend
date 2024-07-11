########################################
# Author: Arthur M Passos, 2024
########################################
# Matrix Multiplication using Bend's default Lists type 
# It transposes the second matrix and just multiplies the lines

########################################
############## List utils ##############
def len(l):
  match l:
    case List/Nil: 
      return 0
    case List/Cons: 
      return len(l.tail) + 1

def getHead(list):
  match list:
    case List/Nil:
      return List/Nil
    case List/Cons:
      return list.head

def getTail(list):
  match list:
    case List/Nil:
      return List/Nil
    case List/Cons:
      return list.tail

def checkCurrentElementExists(list):
  match list:
    case List/Nil:
      return 0
    case List/Cons:
      return 1

def sumMultiplyLists( listA, listB ):
  bend currA = listA, currB = listB:
    when and(checkCurrentElementExists(currA), checkCurrentElementExists(currB)):
      sum = ( getHead(currA) * getHead(currB) ) + fork(getTail(currA), getTail(currB))
    else:
      sum = 0
  return sum

##########################################
############## Matrix utils ##############
def getMatrixXYLen(matrix):
  lenX = len(matrix)
  head = getHead(matrix)
  tail = getTail(matrix)
  lenY = len(head)
  return (lenX, lenY)

def calculateMultLine(lineMA, mB):
  bend currB = mB:
    when checkCurrentElementExists(currB):
      value = sumMultiplyLists(lineMA, getHead(currB))
      resultLine = List/Cons { head: value, tail: fork( getTail(currB) ) }
    else:
      resultLine = List/Nil
  return resultLine

##########################################
############## Transposing ###############
def transposeMatrix(matrix):
  bend mIterator = matrix:
    when checkCurrentElementExists(getHead(mIterator)):
      value = currentColToList(mIterator)
      walkedIterator = walkNextMatrixCol(mIterator)
      result = List/Cons { head: value, tail: fork(walkedIterator) } 
    else: 
      result = List/Nil
  return result

def currentColToList(matrix):
  bend mIterator = matrix:
    when checkCurrentElementExists(mIterator):
      result = List/Cons { head: getHead(getHead(mIterator)), tail: fork(getTail(mIterator))}
    else: 
      result = List/Nil
  return result

def walkNextMatrixCol(matrix):
  fold matrix:
    case List/Nil: 
      newMatrix = List/Nil
    case List/Cons: 
      newMatrix = List/Cons { head: getTail(matrix.head), tail: matrix.tail}
  return newMatrix

##########################################
############ General utils ###############
def and(a, b):
  switch a:
    case 0:
      return 0
    case _:
      return b

##########################################

def matrixMultiply(matrixA, matrixB):
  matrixBT = transposeMatrix(matrixB)
  ( lenAX, lenAY ) = getMatrixXYLen(matrixA)
  ( lenBX, lenBY ) = getMatrixXYLen(matrixBT)
  if (lenBX != lenAX):
    return "ERROR: Wrong matrices size:"
  else:
    bend mA = matrixA, mB = matrixBT:
      when and(checkCurrentElementExists(mA), checkCurrentElementExists(mB)):
        newCurrentLine = calculateMultLine(getHead(mA), mB)
        nextLinesMA = getTail(mA)
        result = List/Cons { head: newCurrentLine, tail: fork(nextLinesMA, mB)}
      else: 
        result = List/Nil
    return result

def main:
  matrixA = [
    [1, 2, 3],
    [4, 5, 6]
  ]
  matrixB = [
    [7, 8],
    [9, 10],
    [11, 12]
  ]
  # matrixA * matrixB = [[58, 64], [139, 154]]

  matrixC = [
    [12, 7, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]
  matrixD = [
    [5, 8, 1],
    [6, 7, 3],
    [4, 5, 9]
  ]
  # matrixC * matrixD = 
  # [[114, 160, 60], 
  #  [74, 97, 73], 
  #  [119, 157, 112]]

  matrixE = [
    [1, 2, 3],
    [3, 4, 5],
    [7, 6, 4]
  ]
  matrixF = [
    [5, 2, 6],
    [5, 6, 7],
    [7, 6, 4]
  ]
  # matrixE * matrixF = 
  # [[36, 32, 32],
  #  [70, 60, 66],
  #  [93, 74, 100]]

  return matrixMultiply(matrixC, matrixD)