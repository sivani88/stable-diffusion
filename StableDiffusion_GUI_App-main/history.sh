<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stable Diffusion App</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/main.css') }}">
</head>
<body>
    <img id="logo" src="{{ url_for('static', filename='images/logo.png') }}" alt="Logo">
    <br>
    <form action="{{ url_for('prompt') }}" method="post">
        <p>What kind of image would you like to generate?</p>
        <br>
        <input id="prompt" type="text" name="prompt_input">
        <br>
        <input id="generate_btn" type="submit" value="GENERATE" onclick="processing();">
    </form>
    <form action="{{ url_for('supersample') }}" method="post">
        {% for i in prompt_images %}
            <img class="generated" src="{{ url_for('static', filename=i) }}" alt="Generated image">
        {% endfor %}
        <br>
        {% for i in btn_range %}
            <button class="save_btn" name="save_btn" type="submit" value="{{ i }}" onclick="saving('{{ i }}');">
                SAVE HD IMAGE
            </button>
        {% endfor %}
    </form>
    <script src="{{ url_for('static', filename='js/main.js') }}"></script>
</body>
</html>