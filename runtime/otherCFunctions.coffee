
strcmp = (str1, str2) ->
  if str1 == str2 then 0 else if str1 > str2 then 1 else -1


doubleToReasonableString = (d) ->

  # when generating code, print out
  # the standard JS Number printout
  if codeGen
    return "" + d


  if (isZeroAtomOrTensor(get_binding(symbol(FORCE_FIXED_PRINTOUT))))
    stringRepresentation = "" + d
    # manipulate the string so that it can be parsed by
    # Algebrite (something like 1.23e-123 wouldn't cut it because
    # that would be parsed as 1.23*e - 123)

    if printMode == PRINTMODE_LATEX
      # 1\mathrm{e}{-10} looks much better than the plain 1e-10
      stringRepresentation = stringRepresentation.replace(/e(.*)/gm, "\\mathrm{e}{$1}");
    else
      stringRepresentation = stringRepresentation.replace(/e(.*)/gm, "*10^($1)");

  else
    push(get_binding(symbol(MAX_FIXED_PRINTOUT_DIGITS)))
    maxFixedPrintoutDigits = pop_integer()
    #console.log "maxFixedPrintoutDigits: " + maxFixedPrintoutDigits
    #console.log "type: " + typeof(maxFixedPrintoutDigits)
    #console.log "toFixed: " + d.toFixed(maxFixedPrintoutDigits)

    stringRepresentation = "" + d.toFixed(maxFixedPrintoutDigits)

    # remove any trailing zeroes after the dot
    # see https://stackoverflow.com/questions/26299160/using-regex-how-do-i-remove-the-trailing-zeros-from-a-decimal-number
    stringRepresentation = stringRepresentation.replace(/(\.\d*?[1-9])0+$/gm, "$1")
    # in case there are only zeroes after the dot, removes the dot too
    stringRepresentation = stringRepresentation.replace(/\.0+$/gm, "")

    # we actually want to give a hint to user that
    # it's a double, so add a trailing ".0" if there
    # is no decimal point
    if stringRepresentation.indexOf(".") == -1 
      stringRepresentation += ".0"

    if parseFloat(stringRepresentation) != d
      stringRepresentation = d.toFixed(maxFixedPrintoutDigits) + "..."


  return stringRepresentation

# does nothing
clear_term = ->

# s is a string here anyways
isspace = (s) ->
  if !s? then return false
  return s == ' ' or s == '\t' or s == '\n' or s == '\v' or s == '\f' or s == '\r'

isdigit = (str) ->
  if !str? then return false
  return /^\d+$/.test(str)

isalpha = (str) ->
  if !str? then return false
  #Check for non-alphabetic characters and space
  return (str.search(/[^A-Za-z\u00C0-\u017E\u0370-\u03FF]/) == -1)

isalphaOrUnderscore = (str) ->
  if !str? then return false
  #Check for non-alphabetic characters and space
  return (str.search(/[^A-Za-z\u00C0-\u017E\u0370-\u03FF_]/) == -1)

isunderscore = (str) ->
  if !str? then return false
  return (str.search(/_/) == -1)

isalnumorunderscore = (str) ->
  if !str? then return false
  return (isalphaOrUnderscore(str) or isdigit(str))
