import asyncio
import requests

async def send_request(node):
    response = requests.get(node)
    if response.status_code == 200:
        try:
            data = response.json()
            status = data['status']
            if status == 'OK':
                # Extract the relevant part of the URL using string slicing
                node_name = node[7:-8]
                print(f'The status for {node_name} is: {status}')
            else:
                print(f'The node {node} is down')
        except ValueError:
            print(f'The response for {node} is not a valid JSON object')
    else:
        print(f'An error occurred for {node}:', response.status_code)

# The nodes from the explorer
nodes = ['http://blocksum.org:11898/getinfo', 'http://swepool.org:11898/getinfo', 'http://Tifo.info:11898/getinfo',
         'http://pool.gamersnest.org:11898/getinfo', 'http://gota.kryptokrona.se:11898/getinfo', 'http://wasa.kryptokrona.se:11898/getinfo',
         'http://spider-pig.hopto.org:11898/getinfo', 'http://privacymine.net:11898/getinfo', 'http://privacymine.net:21898/getinfo',       
         'http://techy.ddns.net:11898/getinfo', 'http://182.43.36.18:11898/getinfo', 'http://106.12.131.174:11898/getinfo',
         'http://norpool.org:11898/getinfo', 'http://115.239.210.250:11898/getinfo', 'http://182.43.80.115:11898/getinfo']

loop = asyncio.get_event_loop()
tasks = [send_request(node) for node in nodes]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()