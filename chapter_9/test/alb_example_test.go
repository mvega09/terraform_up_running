package test

import (
  "fmt"
  "testing"
  "time"

  "github.com/gruntwork-io/terratest/modules/http-helper"
  "github.com/gruntwork-io/terratest/modules/random"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/require"
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

func TestAlbExamplePlan(t *testing.T) {
  t.Parallel()
  
  albName := fmt.Sprintf("test-%s", random.UniqueId())
  
  opts := &terraform.Options{
    // ¡Deberías actualizar esta ruta relativa para apuntar
    // a tu directorio de ejemplo alb!
    TerraformDir: "../examples/alb",
    
    Vars: map[string]interface{}{
      "alb_name": albName,
    },
  }
  
  planString := terraform.InitAndPlan(t, opts)

  // Un ejemplo de cómo verificar los conteos add/change/destroy de la salida del plan
  resourceCounts := terraform.GetResourceCount(t, planString)
  require.Equal(t, 3, resourceCounts.Add)
  require.Equal(t, 0, resourceCounts.Change)
  require.Equal(t, 0, resourceCounts.Destroy)

  // Un ejemplo de cómo verificar valores específicos en la salida del plan
  planStruct := 
    terraform.InitAndPlanAndShowWithStructNoLogTempPlanFile(t, opts)

  alb, exists := 
    planStruct.ResourcePlannedValuesMap["module.alb.aws_lb.terramino"]
  require.True(t, exists, "aws_lb resource must exist")

  name, exists := alb.AttributeValues["name"]
  require.True(t, exists, "missing name parameter")

  // Espera el nombre con el sufijo -alb
  expectedName := fmt.Sprintf("%s-alb", albName)
  require.Equal(t, expectedName, name)
}