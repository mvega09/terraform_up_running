package test

import (
  "fmt"
  "testing"
  "strings"
  "time"

  "github.com/gruntwork-io/terratest/modules/http-helper"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestHelloWorldAppExample(t *testing.T) {
  opts := &terraform.Options{
    // ¡Deberías actualizar esta ruta relativa para apuntar
    // a tu directorio de ejemplo hello-world-app!
    TerraformDir: "../examples/hello-world-app/standalone",
    
    Vars: map[string]interface{}{
        "mysql_config": map[string]interface{}{
            "address": "mock-value-for-test",
            "port":    3306,
        },
    },
  }
  
  // Limpiar todo al final de la prueba
  defer terraform.Destroy(t, opts)
  
  terraform.InitAndApply(t, opts)
  
  albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
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
      return status == 200 && (
        strings.Contains(body, "Hello, World") ||
        strings.Contains(body, "¡Hola desde Terraform y AWS!")
      )
    },
  )
}