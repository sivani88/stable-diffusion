from flask import Flask, render_template, request
from PIL import Image
import secrets
from diffusers import StableDiffusionPipeline

app = Flask(__name__)
app.config['SECRET_KEY'] = secrets.token_hex(16)

pipeline = StableDiffusionPipeline.from_pretrained("./stable-diffusion-v1-4")

@app.route('/')
def hello():
    return render_template("index.html")

@app.route('/prompt', methods=['POST'])
def prompt():
    prompt_text = request.form.get('prompt_input', '').strip()
    if not prompt_text:
        return render_template("index.html", error="No prompt provided!")

    print("User prompt received:", prompt_text)
    try:
        image = pipeline(prompt_text).images[0]
        image_path = "static/images/demo_img0.png"
        image.save(image_path)
    except Exception as e:
        print(f"An error occurred: {e}")
        return render_template("index.html", error=str(e))

    return render_template("index.html", prompt_image=f"/{image_path}")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
