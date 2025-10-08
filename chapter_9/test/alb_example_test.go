package test

import (
  "fmt"
  "testing"
  "time"

  "github.com/gruntwork-io/terratest/modules/http-helper"
  "github.com/gruntwork-io/terratest/modules/random"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAlbExample(t *testing.T) {
  t.Parallel()
  opts := &terraform.Options{
    // ¡Deberías actualizar esta ruta relativa para apuntar
    // a tu directorio de ejemplo alb!
    TerraformDir: "../examples/alb",

    Vars: map[string]interface{}{
      "alb_name": fmt.Sprintf("test-%s", random.UniqueId()),
    },
  }

  // Limpiar todo al final de la prueba
  defer terraform.Destroy(t, opts)

  // Desplegar el ejemplo
  terraform.InitAndApply(t, opts)

  albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
  url := fmt.Sprintf("http://%s", albDnsName)

  // Probar que la acción predeterminada del ALB está funcionando y devuelve un 404
  expectedStatus := 404
  expectedBody := "404: page not found"
  maxRetries := 10
  timeBetweenRetries := 10 * time.Second
  
  http_helper.HttpGetWithRetry(
    t,
    url,
    nil,
    expectedStatus,
    expectedBody,
    maxRetries,
    timeBetweenRetries,
  )
}