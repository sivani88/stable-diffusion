from flask import Flask, render_template, request
from PIL import Image
import secrets
from diffusers import StableDiffusionPipeline

app = Flask(__name__)

# Générer une clé secrète aléatoire
app.config['SECRET_KEY'] = secrets.token_hex(16)

# Charger le pipeline Stable Diffusion
pipeline = StableDiffusionPipeline.from_pretrained("./stable-diffusion-v1-4")
pipeline.enable_freeu(b1=1.3, b2=1.4, s1=0.9, s2=0.2)

@app.route('/')
def home():
    # Page d'accueil
    return render_template(
        "index.html", 
        prompt_image="/static/images/placeholder_image.png"  # L'image par défaut
    )

@app.route('/prompt', methods=['POST'])
def prompt():
    # Générer une image à partir de la saisie utilisateur
    prompt_text = request.form.get('prompt_input', '').strip()
    if not prompt_text:
        return render_template("index.html", error="No prompt provided!", prompt_image="/static/images/placeholder_image.png")

    print("User prompt received:", prompt_text)

    try:
        # Générer une image à partir du prompt
        image = pipeline(prompt_text).images[0]
        # Enregistrer l'image
        image_path = "static/images/demo_img0.png"
        image.save(image_path)
    except Exception as e:
        print(f"An error occurred: {e}")
        return render_template("index.html", error=str(e), prompt_image="/static/images/placeholder_image.png")

    return render_template(
        "index.html", 
        prompt_image=f"/static/images/demo_img0.png"
    )

if __name__ == '__main__':
    # Lancer l'application
    app.run(
        host='0.0.0.0', 
        port=8000, 
        debug=True
    )
