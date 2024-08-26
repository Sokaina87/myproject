import requests
import rasterio
from rasterio.io import MemoryFile

def get_image_coordinates(url):
    response = requests.get(url)

    if response.status_code == 200:
        with MemoryFile(response.content) as memfile:
            with memfile.open() as dataset:
                coords = dataset.bounds
                return {
                    'west': coords.left,
                    'south': coords.bottom,
                    'east': coords.right,
                    'north': coords.top
                }
    else:
        print(f"Error fetching image: {response.status_code}")
        return None

# URL de l'image satellite (par exemple GeoTIFF)
image_url = (r'https://opendata.digitalglobe.com'
             r'/events/mauritius-oil-spill'
             r'/post-event/2020-08-12/105001001F1B5B00'
             r'/105001001F1B5B00.tif')
coordinates = get_image_coordinates(image_url)

if coordinates:
    print("Coordinates:", coordinates)