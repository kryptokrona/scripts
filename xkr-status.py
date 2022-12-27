import os
import colorama
from colorama import Fore
import requests
import time

os.system('clear')

def check_site(url):
    start_time = time.time()
    try:
        response = requests.get(url)
        elapsed_time = (time.time() - start_time) * 1000
        if response.status_code == 200:
            if elapsed_time > 2000:
                print((Fore.MAGENTA + f'Host: {url}\n') + (Fore.GREEN + 'Status: OK\n') + (Fore.RED + f'Ping: {elapsed_time: .0f} ms'))
            elif elapsed_time > 1000:
                print((Fore.MAGENTA + f'Host: {url}\n') + (Fore.GREEN + 'Status: OK\n') + (Fore.YELLOW + f'Ping: {elapsed_time: .0f} ms'))
            else:
                print((Fore.MAGENTA + f'Host: {url}\n') + (Fore.GREEN + 'Status: OK\n') + (Fore.GREEN + f'Ping: {elapsed_time: .0f} ms'))
        else:
            print(f'Host: {url} Status: Error {response.status_code}')
    except requests.RequestException as e:
        print((Fore.RED + f'An error occurred while sending the request to {url}'))

def check_node(node):
    start_time = time.time()
    try:
        response = requests.get(node)
        elapsed_time = (time.time() - start_time) * 1000
        if response.status_code == 200:
            if elapsed_time > 2000:
                    node_name = node[7:-8]
                    print((Fore.BLUE + f'Host: {node_name}\n') + (Fore.RED + 'Status: OK\n') + f'Ping: {elapsed_time: .0f} ms')
            elif elapsed_time > 1000:
                     node_name = node[7:-8]
                     print((Fore.BLUE + f'Host: {node_name}\n') + (Fore.YELLOW + 'Status: OK\n') + f'Ping: {elapsed_time: .0f} ms')
            else:
                    node_name = node[7:-8]
                    print((Fore.BLUE + f'Host: {node_name}\n') + (Fore.GREEN + 'Status: OK\n') + f'Ping: {elapsed_time: .0f} ms')
        else:
            print(f'An error occurred for {node}', response.status_code)
    except requests.RequestException as e:
        print((Fore.RED + f'An error occurred while sending the request to {node}'))

# Kryptokrona related sites
urls = ['https://www.kryptokrona.org', 'https://docs.kryptokrona.org', 'https://explorer.kryptokrona.org', 'https://explorer.kryptokrona.se', 'https://cli.hugin.chat']

# The nodes from the explorer
nodes = ['http://blocksum.org:11898/getinfo', 'http://swepool.org:11898/getinfo', 'http://Tifo.info:11898/getinfo',
    'http://gota.kryptokrona.se:11898/getinfo', 'http://wasa.kryptokrona.se:11898/getinfo',
    'http://spider-pig.hopto.org:11898/getinfo', 'http://privacymine.net:11898/getinfo', 'http://privacymine.net:21898/getinfo',
    'http://techy.ddns.net:11898/getinfo', 'http://106.12.131.174:11898/getinfo',
    'http://norpool.org:11898/getinfo', 'http://115.239.210.250:11898/getinfo', 'http://182.43.80.115:11898/getinfo']

def main():
    print('Kryptokrona related sites:')
    for url in urls:
        check_site(url)
    print('')
    print('Kryptokrona nodes:')
    for node in nodes:
        check_node(node)

main()
