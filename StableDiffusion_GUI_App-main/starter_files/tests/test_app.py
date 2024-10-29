import unittest
from app import app

class FlaskAppTests(unittest.TestCase):
    
    # Set up the test client
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    # Test route '/'
    def test_home(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)  # Check that the page loads successfully
        self.assertIn(b'prompt_images', response.data)  # Check if 'prompt_images' is in the HTML response

    # Test route '/prompt'
    def test_prompt(self):
        response = self.app.post('/prompt', data={'prompt_input': 'A sunset over the ocean'})
        self.assertEqual(response.status_code, 200)  # Check that the request was successful
        self.assertIn(b'static/images/demo_img0.png', response.data)  # Check if the generated image is in the response

    # Test route '/supersample'
    def test_supersample(self):
        response = self.app.post('/supersample', data={'save_btn': '0'})
        self.assertEqual(response.status_code, 200)  # Check that the request was successful
        # Check if the image was supersampled and saved
        self.assertIn(b'static/images/demo_img0.png', response.data)

    # Test route '/image/<image_name>'
    def test_image_detail(self):
        response = self.app.get('/image/demo_img0')
        self.assertEqual(response.status_code, 200)  # Check that the detail view loads successfully
        self.assertIn(b'static/images/saved/demo_img0.png', response.data)

if __name__ == '__main__':
    unittest.main()
