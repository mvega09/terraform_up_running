package test

import (
  "fmt"
  "strings"
  "testing"
  "time"

  "github.com/gruntwork-io/terratest/modules/http-helper"
  "github.com/gruntwork-io/terratest/modules/random"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/gruntwork-io/terratest/modules/test-structure"
)

// Reemplaza estos con las rutas apropiadas a tus módulos
const dbDirStage = "../live/stage/data-stores/mysql"
const appDirStage = "../live/stage/services/hello-world-app"

// Rutas para entorno de Producción
const dbDirProd = "../live/prod/data-stores/mysql" // para realizar pruebas en entorno de produccion (Recuerda que estas pruebas se deben realizar en una cuenta aislada de aws donde no este el codigo en produccion)
const appDirProd = "../live/prod/services/hello-world-app" // para realizar pruebas en entorno de produccion (Recuerda que estas pruebas se deben realizar en una cuenta aislada de aws donde no este el codigo en produccion)

func TestHelloWorldAppStage(t *testing.T) {
  t.Parallel()
  
  // Desplegar la base de datos MySQL
  dbOpts := createDbOpts(t, dbDirStage)
  defer terraform.Destroy(t, dbOpts)
  terraform.InitAndApply(t, dbOpts)
  
  // Desplegar la hello-world-app
  helloOpts := createHelloOpts(dbOpts, appDirStage)
  defer terraform.Destroy(t, helloOpts)
  terraform.InitAndApply(t, helloOpts)
  
  // Validar que la hello-world-app funciona
  validateHelloApp(t, helloOpts)
}

func createDbOpts(t *testing.T, terraformDir string) *terraform.Options {
  uniqueId := random.UniqueId()
  
  bucketForTesting := "my-bucket-mvega09"
  bucketRegionForTesting := "us-east-2"
  
  dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), uniqueId)
  
  return &terraform.Options{
    TerraformDir: terraformDir,
    
    Vars: map[string]interface{}{
      "db_name":     fmt.Sprintf("test%s", uniqueId),
      "db_username": "admin",
      "db_password": "password",
    },
    
    BackendConfig: map[string]interface{}{
      "bucket":  bucketForTesting,
      "region":  bucketRegionForTesting,
      "key":     dbStateKey,
      "encrypt": true,
    },
  }
}

func createHelloOpts(
  dbOpts *terraform.Options,
  terraformDir string) *terraform.Options {
  
  return &terraform.Options{
    TerraformDir: terraformDir,
    
    Vars: map[string]interface{}{
      "db_remote_state_bucket": dbOpts.BackendConfig["bucket"],
      "db_remote_state_key":    dbOpts.BackendConfig["key"],
      "environment":            dbOpts.Vars["db_name"],
    },
    
    // Reintentar hasta 3 veces, con 5 segundos entre reintentos,
    // en errores conocidos
    MaxRetries:         3,
    TimeBetweenRetries: 5 * time.Second,
    RetryableTerraformErrors: map[string]string{
      "RequestError: send request failed": "Throttling issue?",
    },
  }
}

func validateHelloApp(t *testing.T, helloOpts *terraform.Options) {
  albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
  url := fmt.Sprintf("http://%s", albDnsName)
  
  maxRetries := 10
  timeBetweenRetries := 10 * time.Second
  
  http_helper.HttpGetWithRetryWithCustomValidation(
    t,
    url,
    nil,
    maxRetries,
    timeBetweenRetries,
    func(status int, body string) bool {
      return status == 200 &&
        (strings.Contains(body, "Hello, World") ||
          strings.Contains(body, "¡Hola desde Terraform y AWS!"))
    },
  )
}

func TestHelloWorldAppStageWithStages(t *testing.T) {
  t.Parallel()
  
  // Almacenar la función en un nombre de variable corto únicamente para
  // hacer que los ejemplos de código quepan mejor en el libro.
  stage := test_structure.RunTestStage
  
  // Desplegar la base de datos MySQL
  defer stage(t, "teardown_db", func() { teardownDb(t, dbDirStage) })
  stage(t, "deploy_db", func() { deployDb(t, dbDirStage) })
  
  // Desplegar la hello-world-app
  defer stage(t, "teardown_app", func() { teardownApp(t, appDirStage) })
  stage(t, "deploy_app", func() { deployApp(t, dbDirStage, appDirStage) })
  
  // Validar que la hello-world-app funciona
  stage(t, "validate_app", func() { validateApp(t, appDirStage) })
}

func deployDb(t *testing.T, dbDir string) {
  dbOpts := createDbOpts(t, dbDir)
  
  // Guardar datos en disco para que otras etapas de prueba ejecutadas
  // en un momento posterior puedan leer los datos de vuelta
  test_structure.SaveTerraformOptions(t, dbDir, dbOpts)
  
  terraform.InitAndApply(t, dbOpts)
}

func teardownDb(t *testing.T, dbDir string) {
  dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
  defer terraform.Destroy(t, dbOpts)
}

func deployApp(t *testing.T, dbDir string, helloAppDir string) {
  dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
  helloOpts := createHelloOpts(dbOpts, helloAppDir)
  
  // Guardar datos en disco para que otras etapas de prueba ejecutadas
  // en un momento posterior puedan leer los datos de vuelta
  test_structure.SaveTerraformOptions(t, helloAppDir, helloOpts)
  
  terraform.InitAndApply(t, helloOpts)
}

func teardownApp(t *testing.T, helloAppDir string) {
  helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
  defer terraform.Destroy(t, helloOpts)
}

func validateApp(t *testing.T, helloAppDir string) {
  helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
  validateHelloApp(t, helloOpts)
}


// Tener en cuenta antes de correr esta funciones 'TestHelloWorldAppStageWithStages' y TestHelloWorldAppProdWithStages ejecutar (pagina 532 pdf del libro)

// Inicialmente
//SKIP_teardown_db=true \
//SKIP_teardown_app=true \
//go test -timeout 30m -run 'TestHelloWorldAppProdWithStages'

// Despues

//SKIP_teardown_db=true \
//SKIP_teardown_app=true \
//SKIP_deploy_db=true \
//go test -timeout 30m -run 'TestHelloWorldAppProdWithStages'

// Finalmente para eliminar los recursos creados en AWS

//SKIP_deploy_db=true \
//SKIP_deploy_app=true \
//SKIP_validate_app=true \
//go test -timeout 30m -run 'TestHelloWorldAppProdWithStages'



func TestHelloWorldAppProdWithStages(t *testing.T) {
	t.Parallel()

	// Deploy the MySQL DB
	defer test_structure.RunTestStage(t, "teardown_db", func() { teardownDb(t, dbDirProd) })
	test_structure.RunTestStage(t, "deploy_db", func() { deployDb(t, dbDirProd) })

	// Deploy the hello-world-app
	defer test_structure.RunTestStage(t, "teardown_app", func() { teardownApp(t, appDirProd) })
	test_structure.RunTestStage(t, "deploy_app", func() { deployApp(t, dbDirProd, appDirProd) })

	// Validate the hello-world-app works
	test_structure.RunTestStage(t, "validate_app", func() { validateApp(t, appDirProd) })
}