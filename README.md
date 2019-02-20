# Environs

The project introduces concept of Environs, which are level of abstraction to simplify Development, Testing and Demos.
(Author believes that this is new concept, so new term was introduced to avoid confusion with other similar terms, which may be also suitable here, but would not explicitly define what is going on).

On practice Environ is a folder which contains set of wrapper scripts, which allow to:
- define common interface for similar product / version / deployment type of various products;
- define fully automated scripting scenarios without getting into details of involved products depending on version / vendor / underlying OS / etc.

The key feature of Environs comparing to regular scripting is usage of templates with predefined paths and other parameters like ports, user names, access keys, etc. This way eventual complexity and variety of products usage will be hidden behind generated scripts. I.e. scripting and actual usage scenarios will be the same without specifics of involved products.

The concept further in shown in EXAMPLE.md
