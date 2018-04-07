import csv
import sys
from datetime import datetime, timedelta
from time import sleep
from collections import deque


def clamp(n, minn, maxn): return min(max(n, minn), maxn)


class Clock:
    def __init__(self):
        self.start = datetime(2014, 1, 1, 0, 0)
        self.now = self.start

    def tick(self):
        self.now = self.now + timedelta(minutes=1)

    def sanctioned(self):
        return (self.now.hour >= 9 and self.now.hour < 19)

    def unsanctioned(self):
        return not (self.now.hour >= 9 and self.now.hour < 19)

class Toy:
    def __init__(self, toy_id, startdate, worktime):
        self.id = toy_id
        self.startdate = startdate
        self.worktime = worktime
        self.workleft = float(worktime)
        self.complete = False

    def work(self, worker):
        self.workleft -= worker.productivity

        if self.workleft <= 0:
            return True
        else:
            return False

class Elf:
    def __init__(self, elf_id):
        self.id = elf_id
        self.productivity = 1.0
        self.worktime = 0
        self.overtime = 0

        self.resting = False
        self.working = False

        self.toy = None

        self.completed = 0

    def assign(self, toy):
        if(self.toy == None and self.overtime == 0):
            self.toy = toy
            return True
        return False

    def update(self, time):
        if self.toy is None:
            if (time.sanctioned() and self.overtime > 0):
                self.overtime -= 1
                self.resting = True
                return None

            else:
                self.working = False
                self.resting = False
                return None
        else:
            self.working = True
            self.resting = False

            if(time.unsanctioned()):
                self.overtime += 1
            else:
                self.worktime += 1

            if(self.toy.work(self)):
                self.productivity = clamp(self.productivity * ((1.02)**(self.worktime/60.0)) * ((0.9)**(self.overtime/60.0)), 0.25, 4.0)
                self.worktime = 0

                completed_toy = self.toy
                self.toy = None
                self.completed += 1
                return completed_toy

toylist = deque()

with open('toys_1day.csv', 'rt') as csvfile:
    next(csvfile, None)
    spamreader = csv.reader(csvfile)
    for row in spamreader:
        toylist.append(Toy(int(row[0]),datetime.strptime(row[1], "%Y %m %d %H %M"),int(row[2])))



out = False


elves = [Elf(i) for i in range(64)]

clock = Clock()

unfinished_toys = deque()
finished_toys = deque()

if out: print(clock.now)
if out: sys.stdout.write("| working | resting | waiting |\n")

for ii in range(len(elves)):
    if out: sys.stdout.write("\n")

for i in range(100000):


    while (len(toylist) > 0 and toylist[0].startdate == clock.now):
        unfinished_toys.append(toylist.popleft())


    for ii in range(len(elves)):
        if out: sys.stdout.write("\033[F\033[K")


    if out: sys.stdout.write("\033[F\033[K")
    if out: sys.stdout.write("\033[F\033[K")

    while(len(finished_toys)>0):
        if out: print([finished_toys[0].id, finished_toys[0].worktime])
        finished_toys.popleft()

    if out: print(clock.now)
    if out: sys.stdout.write("|    working    |    resting    |    waiting    |\n")

    for elf in elves:

        if elf.toy is None and len(unfinished_toys) > 0:
            if(elf.assign(unfinished_toys[0])):
                unfinished_toys.popleft()

        finished_toy = elf.update(clock)

        if elf.working:
            pass
        elif elf.resting:
            if out: sys.stdout.write("|               ")
        else:
            if out: sys.stdout.write("|               |               ")

        if out: sys.stdout.write("| "+str(elf.id)+"-"+str(elf.overtime)+"-"+str(elf.completed)+"-"+str(round(elf.productivity,1))+"\n")   


        if finished_toy is not None:
            finished_toys.append(finished_toy)

    if(len(toylist) == 0 and len(unfinished_toys) == 0):
        print("all toys done, total time: "+str(clock.now-clock.start))
        break

    clock.tick()
    if out: sleep(0.01)