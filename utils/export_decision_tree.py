import os
from sklearn.tree import export_graphviz, export_text
from subprocess import call

# https://stackoverflow.com/questions/35064304/runtimeerror-make-sure-the-graphviz-executables-are-on-your-systems-path-aft
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'


def export_decision_tree(decision_tree, feature_names):
    export_decision_tree_to_file(export_text(decision_tree, feature_names))
    export_graphviz(decision_tree, out_file='decision_tree.dot', feature_names=feature_names, rounded=True,
                    precision=1)
    convert_dot_to_svg()


def export_decision_tree_to_file(text):
    with open('decision_tree.txt', 'w') as f:
        print(text, file=f)


def convert_dot_to_svg():
    pass
    # call(['sfdp', '-x', '-Goverlap=scale', '-Tsvg', 'decision_tree.dot', '-o', 'decision_tree.svg'])
