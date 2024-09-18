from flask import Flask, render_template, request
from PIL import Image
import secrets
from diffusers import StableDiffusionPipeline

app = Flask(__name__)
app.config['SECRET_KEY'] = secrets.token_hex(16)

pipeline = StableDiffusionPipeline.from_pretrained("./stable-diffusion-v1-4")
pipeline.enable_freeu(b1= 1.3, b2= 1.4, s1= 0.9, s2= 0.2)

@app.route('/')
def hello():
    # home page
    
    return render_template(
        "index.html", 
        # pass variables into the HTML template
        btn_range = range(3), 
        prompt_images = ["/static/images/placeholder_image.png" for i in range(3)]
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
        # pass variables into the HTML template
        btn_range = range(3), 
        prompt_images = ["static/images/demo_img" + str(i) + ".png" for i in range(3)]
    )

@app.route('/supersample', methods=['POST', 'GET'])
def supersample():
    # enlarge and save prompt image in high quality
    print("save button", request.form['save_btn'], "was clicked!")

    return render_template(
        "index.html", 
        # pass variables into the HTML template
        btn_range = range(3), 
        prompt_images = ["/static/images/placeholder_image.png" for i in range(3)]
    )

if __name__ == '__main__':
    # run application
    app.run(
        host = '0.0.0.0', 
        port = 8000, 
        debug = True
    )   