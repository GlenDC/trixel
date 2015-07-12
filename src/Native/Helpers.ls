# remove an item from a list
this.tr-remove = (arr, item) ->
  for let x, i in arr
    if x == item
      arr.splice i 1

  void


# check if an array is not empty, returning true if so
this.tr-isArrayNonEmpty = (arr) ->
  arr.length > 0