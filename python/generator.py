def fib(times):
    n = 0
    a,b = 0,1
    while n < times:
        yield b
        a,b = b,a+b
        n+=1
    return 'done'


import time

def consumer():
    r = ''
    while True:
        n = yield r
        if not n:
            return
        print('[CONSUMER] Consuming %s...' % n)
        time.sleep(1)
        r = '200 OK'


def produce(c):
    c.__next__()
    n = 0
    while n < 5:
        n = n + 1
        print('[PRODUCER] Producing %s...' % n)
        r = c.send(n)
        print('[PRODUCER] Consumer return: %s' % r)

    c.close()

if __name__=='__main__':
    c = consumer()
    produce(c)
