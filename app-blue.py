
from flask import Flask
import os

app = Flask(__name__)
color = os.getenv("COLOR", "#0000FF")

@app.route("/")
def home():
    return f"""
    <html>
      <body style='background-color: {color};'>
        <h1>Blue app deployed by Argo CD, Hello from GitOps!</h1>
      </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

