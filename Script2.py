import json
import httpx
from folium import Map, TileLayer
import webbrowser

# Définir l'endpoint du service titiler
titiler_endpoint = "https://titiler.xyz"

# URL de l'image satellite
url = ("https://opendata.digitalglobe.com"
       "/events/mauritius-oil-spill/post-event"
       "/2020-08-12/105001001F1B5B00/105001001F1B5B00.tif")

# Récupérer les métadonnées de l'image pour obtenir les limites
r = httpx.get(
    f"{titiler_endpoint}/cog/info",
    params={
        "url": url,
    }
).json()

bounds = r["bounds"]

# Lire les coordonnées de l'utilisateur
west = float(input("Entrez la longitude ouest : "))
south = float(input("Entrez la latitude sud : "))
east = float(input("Entrez la longitude est : "))
north = float(input("Entrez la latitude nord : "))

# Vérification si les coordonnées sont à l'intérieur des limites de l'image
if west < bounds[0] or east > bounds[2] or south < bounds[1] or north > bounds[3]:
    print("Erreur : Les coordonnées sont à l'extérieur de l'image.")
else:
    # Obtenez les statistiques de l'image
    r = httpx.get(
        f"{titiler_endpoint}/cog/statistics",
        params={
            "url": url,
        }
    ).json()

    print(json.dumps(r, indent=4))

    # Obtenir les propriétés de la carte à partir du COG
    r = httpx.get(
        f"{titiler_endpoint}/cog/WebMercatorQuad/tilejson.json",
        params={
            "url": url,
        }
    ).json()

    # Création de la carte
    m = Map(
        location=((north + south) / 2, (west + east) / 2),
        zoom_start=13
    )

    # Ajouter la couche de tuile
    TileLayer(
        tiles=r["tiles"][0],
        opacity=1,
        attr="DigitalGlobe OpenData"
    ).add_to(m)

    # Enregistrer la carte dans un fichier HTML
    m.save('map.html')

    # Ouvrir le fichier HTML dans le navigateur
    webbrowser.open('map.html')
