from flask import Flask, render_template, request
from PIL import Image
import secrets
from diffusers import StableDiffusionPipeline
from datetime import datetime

app = Flask(__name__)

# Generate random secret key
app.config['SECRET_KEY'] = secrets.token_hex(16)

# Load the Stable Diffusion pipeline
pipeline = StableDiffusionPipeline.from_pretrained("./stable-diffusion-v1-4")
pipeline.enable_freeu(b1=1.3, b2=1.4, s1=0.9, s2=0.2)

@app.route('/')
def hello():
    # Home page
    return render_template(
        "index.html", 
        # Pass variables into the HTML template
        btn_range=range(3), 
        prompt_images=["/static/images/placeholder_image.png" for _ in range(3)]
    )

@app.route('/prompt', methods=['POST', 'GET'])
def prompt():
    # Generate images from user prompt
    prompt_text = request.form.get('prompt_input', '').strip()
    if not prompt_text:
        return render_template("index.html", error="No prompt provided!")

    print("User prompt received:", prompt_text)

    try:
        for i in range(3):
            # Generate an image from the prompt
            image = pipeline(prompt_text).images[0]
            # Save the image
            image.save(f"static/images/demo_img{i}.png")
    except Exception as e:
        print(f"An error occurred: {e}")
        return render_template("index.html", error=str(e))

    return render_template(
        "index.html", 
        # Pass variables into the HTML template
        btn_range=range(3), 
        prompt_images=[f"./static/images/demo_img{i}.png" for i in range(3)]
    )

@app.route('/supersample', methods=['POST', 'GET'])
def supersample():
    # Generate a higher-resolution version of the selected image
    print("Save button", request.form['save_btn'], "was clicked!")

    # Unique name of the image with datetime
    img_id = datetime.now().strftime("%Y%m%d%H%M%S")

    try:
        # Read the demo image that was selected for saving
        demo_img_path = f"./static/images/demo_img{request.form['save_btn']}.png"
        demo_img = Image.open(demo_img_path)

        # Save the image with a unique name
        demo_img.save(f"./static/images/saved/img_{img_id}.png")
    except Exception as e:
        print(f"An error occurred during supersampling: {e}")
        return render_template("index.html", error=str(e))

    return render_template(
        "index.html", 
        # Pass variables into the HTML template
        btn_range=range(3), 
        prompt_images=[f"./static/images/demo_img{i}.png" for i in range(3)]
    )

if __name__ == '__main__':
    # Run application
    app.run(
        host='0.0.0.0', 
        port=8000, 
        debug=True
    )
