"""

--
support modules

write unit tests

fix bugs

--

cache evaluated lists (in specific closure, don't cache all function calls, though)

maybe support pairs better

"""

from closure import Context

class EvalError(Exception):
    pass

SPECIALS = set(['let', 'lambda', 'quote'])

ROOTNS = Context()

class Spair:
    def __init__(self, head=None, tail=None):
        if isinstance(head, int):
            if head < 0: raise ValueError
            elif head == 0:
                self.head = None
                self.tail = None
            else:
                self.head = Spair()
                self.tail = Spair(head - 1)
        elif isinstance(head, bool):
            if head:
                self.head = Spair()
                self.tail = Spair()
            else:
                self.head = None
                self.tail = None
        elif isinstance(head, list):
            if head:
                self.head = Spair(head[0])
                self.tail = Spair(head[1:])
            else:
                self.head = None
                self.tail = None
        else:
            self.head = head
            self.tail = tail

    def evaluate(self, closure):
        if self.head is None:
            raise EvalError, "Evaluating empty list"

        try:
            head, special = closure[self.head.head]
        except KeyError:
            raise EvalError, "Unbound symbol: %s [%s]" % (self.head.head, self.head.head.__class__)
        if not callable(head):
            raise EvalError, "Head is not a function, %s" % head

        if special:
            head(self.tail, closure)
        else:
            head(self.tail.argeval(closure), closure)

    def forall(self): #Could maybe be a recursive yield from
        if self.tail is None:
            return [self.head]
        return [self.head] + self.tail.forall()

    def argeval(self, closure): #could be generalized to map
        if self.head is None:
            return self
        return Spair(self.head.evaluate(closure), self.tail.argeval(closure))

    def _getNumber(self):
        if self.head is None:
            return 0
        if not isinstance(self.head, Spair) or \
                self.head.head is not None:
            raise ValueError
        if self.tail is None:
            return 0
        return 1 + self.tail._getNumber()

    def _toStr(self, start):
        if start:
            prefix = '['
        else:
            prefix = ' '
        if self.head is None:
            if start:
                s = '0'
            else: s = ']'
        else:
            try:
                if start:
                    x = self._getNumber()
                    s = str(x)
                else:
                    raise ValueError
            except ValueError:
                if not isinstance(self.head, Spair):
                    s = str(self.head)
                else:
                    if self.tail == None:
                        suffix = ']'
                    else:
                        suffix = self.tail._toStr(False)
                    s = prefix + str(self.head) + suffix
        return s

    def __repr__(self):
        return self._toStr(True)
    
def _car(context, spair):
    return spair.head

def _cdr(context, spair):
    return spair.tail

def _cons(context, spair):
    return Spair(spair.head, spair.rest.head)

def _quote(context, spair):
    return spair

def _if(context, spair):
    cond = spair.head.evaluate()
    if cond.head:
        return spair.rest.head.evaluate()
    else:
        return spair.rest.rest.head.evaluate()

class Recursive:
    pass

def _let(context, spair):
    c2 = context.new_child()
    for p in spair.head.forall():
        c2[p.head] = Recursive()
        c2[p.head] = p.tail.head.evaluate(c2)
    return spair.tail.head.evaluate(c2)

class Function:
    def __init__(self, body, args, context):
        self.body = body
        self.args = args
        self.context = context

    def __call__(self, acontext, spair):
        c2 = self.context.new_child()
        for arg in self.args:
            c2[arg] = spair.head.evaluate(acontext)
            spair = spair.rest
        self.body.evaluate(c2)

def _lambda(context, spair):
    args = spair.head.forall()
    return Function(spair.tail.head, args, context.new_child)

ROOTNS['car'] = (_car, False)
ROOTNS['cdr'] = (_cdr, False)
ROOTNS['cons'] = (_cons, False)
ROOTNS['quote'] = (_quote, True)
ROOTNS['if'] = (_if, True)
ROOTNS['let'] = (_let, True)
ROOTNS['lambda'] = (_lambda, True)
