from flask import Flask, render_template, request, redirect, url_for
from PIL import Image
import secrets
from diffusers import StableDiffusionPipeline
from datetime import datetime
from opencensus.ext.flask.flask_middleware import FlaskMiddleware
from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.trace.samplers import ProbabilitySampler
import os

app = Flask(__name__)
# generate random secret key
app.config['SECRET_KEY'] = secrets.token_hex(16)

# Fonction pour lire la clé d'instrumentation depuis le fichier
def get_instrumentation_key():
    key_file_path = os.path.join(os.path.dirname(__file__), 'app_insights_key.txt')
    try:
        with open(key_file_path, 'r') as f:
            return f.read().strip()
    except FileNotFoundError:
        print("Fichier de clé Application Insights non trouvé.")
        return None

# Configurer Application Insights
instrumentation_key = get_instrumentation_key()
if instrumentation_key:
    middleware = FlaskMiddleware(
        app,
        exporter=AzureExporter(connection_string=f"InstrumentationKey={instrumentation_key}"),
        sampler=ProbabilitySampler(rate=1.0),
    )
else:
    print("Application Insights n'a pas pu être configuré.")

# Load the Stable Diffusion pipeline
pipeline = StableDiffusionPipeline.from_pretrained("/app/stable-diffusion-v1-4")

@app.route('/')
def hello():
    # Home page
    return render_template(
        "index.html",
        btn_range=range(3),
        prompt_images=["static/images/placeholder_image.png" for _ in range(3)]
    )

@app.route('/prompt', methods=['POST', 'GET'])
def prompt():
    # Generate images from user prompt
    print("user prompt received:", request.form['prompt_input'])
    for i in range(3):
        image = pipeline(request.form['prompt_input']).images[0]
        image.save(f"static/images/demo_img{i}.png")
    return render_template(
        "index.html",
        btn_range=range(3),
        prompt_images=[f"static/images/demo_img{i}.png" for i in range(3)]
    )

@app.route('/supersample', methods=['POST', 'GET'])
def supersample():
    # Enlarge and save prompt image in high quality
    print("save button", request.form['save_btn'], "was clicked!")
    # Unique name of image with datetime
    img_id = datetime.now().strftime("%Y%m%d%H%M%S")
    print("img id:", img_id)
    # Read the demo image that was selected for saving
    demo_img_path = f"static/images/demo_img{request.form['save_btn']}.png"
    demo_img = Image.open(demo_img_path)
    # Enlarge image by a factor of 2
    width, height = demo_img.size
    new_size = (width * 2, height * 2) # You can modify the scaling factor
    enlarged_img = demo_img.resize(new_size, Image.LANCZOS) # LANCZOS gives better quality for enlargement
    # Save the enlarged image in the "saved" folder
    enlarged_img.save(f"static/images/saved/img_{img_id}.png")
    return render_template(
        "index.html",
        btn_range=range(3),
        prompt_images=[f"static/images/demo_img{i}.png" for i in range(3)]
    )

# Detailed view for saved images
@app.route('/image/<image_name>')
def detail_view(image_name):
    # Display the selected image in detail view
    image_path = f'static/images/saved/{image_name}.png'
    return render_template('detail_view.html', image_path=image_path)

if __name__ == '__main__':
    # Run application
    app.run(host='0.0.0.0', port=8000, debug=True)