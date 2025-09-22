from PIL import Image

def get_average_color(image_path):
    # Ouvrir l'image
    img = Image.open(image_path)

    # Réduire l'image à 1 pixel pour obtenir la couleur moyenne
    img = img.resize((1, 1))

    # Récupérer la couleur de ce pixel
    avg_color = img.getpixel((0, 0))
    return avg_color

# Exemple d'utilisation
image_path = "pochette.jpg"  # Mets le chemin vers ta pochette
average_color = get_average_color(image_path)

print("Couleur moyenne (R, G, B):", average_color)

