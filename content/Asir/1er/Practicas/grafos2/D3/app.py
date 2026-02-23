from flask import Flask, render_template, jsonify

app = Flask(__name__)

def read_graph_data(filename):
    nodes = set()
    links = []

    with open(filename, 'r') as file:
        for line in file:
            key, values = line.strip().split(':')
            key = key.strip()
            nodes.add(key)
            for value in values.split(','):
                value = value.strip()
                nodes.add(value)
                links.append({"source": key, "target": value})

    return nodes, links

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/data')
def data():
    nodes, links = read_graph_data(r'D3\data\texto.txt')
    graph = {
        "nodes": [{"id": node} for node in nodes],
        "links": links
    }
    return jsonify(graph)

if __name__ == '__main__':
    app.run(debug=True)