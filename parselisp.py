import re

"""
sillisp interpreter

test prelude

--

analyze cross "on paper"

write updated blog post

"""

class ParseError(Exception):
    pass

def getSymbolEnd(s, i):
    return re.search('\s|\)|$', s[i:]).start() + i

def parse(self, s):
    return self.makeList(s, 0, False)[0]

def makeList(self, s, i, mustend=True):
    retlist = []
    while i < len(s):
        c = s[i]
        if c == '(':
            sublist, i = self.makeList(s, i + 1) 
            retlist.append(sublist)
        elif c == ')':
            break
        elif c == "'":
            sublist, i = self.makeQuote(s, i + 1)
            retlist.append(sublist)
        elif c.isdigit():
            x, i = self.makeInt(s, i)
            retlist.append(x)
        elif c.isspace():
            i += 1
        elif c == '#':
            x, i = self.makeBool(s, i)
            retlist.append(x)
        elif c == ';':
            i = self.removeComment(s, i)
        else:
            x, i = self.makeSymbol(s, i)
            retlist.append(x)
    if i == len(s) and mustend:
        raise ParseError,  ('No matching paranthesis', i)
    return retlist, i + 1

def removeComment(self, s, i):
    j = s.find('\n', i)
    if j == -1: j = len(s)
    return j

def makeInt(self, s, i):
    j = getSymbolEnd(s, i)
    try:
        return int(s[i:j]), j
    except ValueError:
        raise ParseError, ('Bad int', i)

def makeBool(self, s, i):
    if s[i + 1] == 't':
        return True, i + 2
    elif s[i + 1] == 'f':
        return False, i + 2
    else:
        raise ParseError, ('Bad bool', i+1)
        
def makeSymbol(self, s, i):
    j = getSymbolEnd(s, i)
    return s[i:j], j

def makeQuote(self, s, i):
    if s[i] != '(':
        raise ParseError, ('Bad quote', i)
    sublist, i = self.makeList(s, i+1)
    return ['quote', sublist], i
