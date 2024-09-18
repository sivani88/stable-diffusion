from flask import Flask, render_template, request
from PIL import Image, ImageOps
import secrets
from diffusers import StableDiffusionPipeline
from datetime import datetime

app = Flask(__name__)

# generate random secret key
app.config['SECRET_KEY'] = secrets.token_hex(16)

# Load the Stable Diffusion pipeline
pipeline = StableDiffusionPipeline.from_pretrained("./stable-diffusion-v1-4")


@app.route('/')
def hello():
    # home page
    return render_template(
        "index.html", 
        btn_range=range(3), 
        prompt_images=["static/images/placeholder_image.png" for _ in range(3)]
    )

@app.route('/prompt', methods=['POST', 'GET'])
def prompt():
    # generate images from user prompt
    print("user prompt received:", request.form['prompt_input'])

    for i in range(3):
        image = pipeline(request.form['prompt_input']).images[0]
        image.save("static/images/demo_img" + str(i) + ".png")

    return render_template(
        "index.html", 
        btn_range=range(3), 
        prompt_images=["static/images/demo_img" + str(i) + ".png" for i in range(3)]
    )

@app.route('/supersample', methods=['POST', 'GET'])
def supersample():
    # enlarge and save prompt image in high quality
    print("save button", request.form['save_btn'], "was clicked!")

    # Unique name of image with datetime
    img_id = datetime.now().strftime("%Y%m%d%H%M%S")
    print("img id:", img_id)

    # Read the demo image that was selected for saving
    demo_img_path = "static/images/demo_img" + str(request.form['save_btn']) + ".png"
    demo_img = Image.open(demo_img_path)

    # Enlarge image by a factor of 2 (or any other factor)
    width, height = demo_img.size
    new_size = (width * 2, height * 2)  # You can modify the scaling factor
    enlarged_img = demo_img.resize(new_size, Image.LANCZOS)  # LANCZOS gives better quality for enlargement

    # Save the enlarged image
    enlarged_img.save("static/images/saved/img_" + img_id + ".png")

    return render_template(
        "index.html", 
        btn_range=range(3), 
        prompt_images=["static/images/demo_img" + str(i) + ".png" for i in range(3)]
    )

if __name__ == '__main__':
    # run application
    app.run(host='0.0.0.0', port=8000, debug=True)
