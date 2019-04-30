from pyswip import Prolog, cleanupProlog

envirorments = [
    {
        'bh': 10,
        'bw': 10,
        'time': 50,
        'child_count': 1,
        'dirtiness_percent': 0,
        'obstacle_percent': 50
    }
]


def run_env(env):
    p = Prolog()
    p.consult("main.pl")
    p.assertz("bh(%s)" % env["bh"])
    p.assertz("bw(%s)" % env["bw"])
    p.assertz("time(%s)" % env["time"])
    p.assertz("child_count(%s)" % env["child_count"])
    p.assertz("dirtiness_percent(%s)" % env["dirtiness_percent"])
    p.assertz("obstacle_percent(%s)" % env["obstacle_percent"])
    # list(p.query("findall(_,main,_)"))
    list(p.query("init."))
    # list(p.query("summary."))

    for result in p.query("summaryPy(Avg,RobotFired,ChildInCorral,CleanHouse)"):
        avg = result["Avg"]
        robot_fired = result["RobotFired"]
        child_in_corral = result["ChildInCorral"]
        clean_house = result["CleanHouse"]

    # print(avg,robot_fired,child_in_corral,clean_house)
    return (avg, robot_fired, child_in_corral, clean_house)


result = []
for env in envirorments:
    for _ in range(1):
        result.append(run_env(env))
        print(result)


# for env in envirorments:
#     for _ in range(1):
#         result.append(run_env(env))
#         print(result)
# for env in envirorments:
#     for _ in range(1):
#         result.append(run_env(env))
#         print(result)

print(result)

# p = Prolog()
# p.consult("main.pl")
# p.assertz("bh(10)")

# # cleanupProlog()


# q = Prolog()
# q.retractall("bh")
# q.consult("main.pl")
# print(list(q.query("bh(X)"))[0])
