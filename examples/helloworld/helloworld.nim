import rodster

let app = newRodsterApplication()
app.setInitializationHandler proc (app: RodsterApplication) = stdout.write "hello"
app.setMainRoutine proc (app: RodsterApplication) = stdout.write " world"
app.setFinalizationHandler proc (app: RodsterApplication) = echo "!"
app.run()

