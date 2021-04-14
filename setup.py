try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

readme = ''

with open("VERSION.txt") as version_txt:
    version = [line for line in version_txt.readlines()][0].strip()

setup(
    long_description=readme,
    name='mypylib',
    version=version,
    python_requires='==3.*,>=3.9.0',
    author='Luis Santana',
    author_email='l.santana@globant.com',
    packages=['myns1.myns2.mypylib'],
    package_dir={"": "."},
    package_data={},
    install_requires=[],
)
