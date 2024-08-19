import os
import json
import webbrowser
from functools import partial
from concurrent import futures
import httpx
import numpy
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from io import BytesIO
from tqdm.notebook import tqdm
from folium import Map, GeoJson
from rasterio.features import bounds as featureBounds

# URL de l'endpoint titiler
titiler_endpoint = "https://titiler.xyz"  # Endpoint de démonstration Developmentseed

# Nouveau GeoJSON avec des coordonnées différentes
geojson = {
    "type": "FeatureCollection",
    "features": [
        {
            "type": "Feature",
            "properties": {},
            "geometry": {
                "type": "Polygon",
                "coordinates": [[[-7.741232, 31.676843], 
                                 [-7.741232, 31.58252], 
                                 [-7.628943, 31.58252], 
                                 [-7.628943, 31.676843], 
                                 [-7.741232, 31.676843]]]
            }
        }
    ]
}

# Calculer les limites du polygone
bounds = featureBounds(geojson)

# Créer la carte
m = Map(
    tiles="OpenStreetMap",
    location=((bounds[1] + bounds[3]) / 2, (bounds[0] + bounds[2]) / 2),
    zoom_start=10
)

# Ajouter le GeoJSON à la carte
GeoJson(geojson).add_to(m)

# Sauvegarder la carte en tant que fichier HTML
m.save('map.html')

# Ouvrir la carte dans le navigateur
webbrowser.open('map.html')
