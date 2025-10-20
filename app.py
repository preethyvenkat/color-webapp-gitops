from flask import Flask
import os

app = Flask(__name__)
color = os.getenv("COLOR", "#FFBF00")

@app.route("/")
def home():
    return f"""
    <html>
      <body style='background-color: {color};'>
        <h1>Color-changing app deployed by Argo CD + Argo rollout, Hello from GitOps!</h1>
      </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

