from argparse import ArgumentParser
from datetime import datetime
from time import sleep
from xai_components.xai_tvb_connectivity.connectivity import ConnectivityFromFile
from xai_components.xai_tvb_coupling.coupling import LinearCoupling
from xai_components.xai_tvb_models.stefanescu_jirsa import ReducedSetHindmarshRose
from xai_components.xai_tvb_integrators.integrators import HeunStochastic
from xai_components.xai_tvb_monitors.monitors import Raw

def main(args):

    ctx = {}
    ctx['args'] = args

    c_1 = ConnectivityFromFile()
    c_2 = LinearCoupling()
    c_3 = ReducedSetHindmarshRose()
    c_4 = HeunStochastic()
    c_5 = Raw()


    c_1.next = c_2
    c_2.next = c_3
    c_3.next = c_4
    c_4.next = c_5
    c_5.next = None

    next_component = c_1
    while next_component:
        is_done, next_component = next_component.do(ctx)

if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--experiment_name', default=datetime.now().strftime('%Y-%m-%d %H:%M:%S'), type=str)
    main(parser.parse_args())
    print("\nFinish Executing")