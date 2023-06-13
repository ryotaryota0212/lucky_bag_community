package main

import (
	"log"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/stripe/stripe-go/v74"
	"github.com/stripe/stripe-go/v74/customer"
	"github.com/stripe/stripe-go/v74/paymentintent"
)

func main() {
	stripe.Key = "sk_test_51MxRfkFYbsbXmSwa9ll8EQb5lo8aMN0ZuxUfCi4pvrhGmfKiXz8lI0FBin3qscADBLxvqgAEvfHiK1QOHbRLD1TN00kzxRvE4H"

	router := gin.Default()

	// CORS設定
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Authorization"}
	router.Use(cors.New(config))
	router.POST("/create-payment-intent", createPaymentIntent)

	router.Run(":8100")
}

func createPaymentIntent(c *gin.Context) {
	var requestData map[string]string
	if err := c.BindJSON(&requestData); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request data"})
		return
	}
	paramCustomer := &stripe.CustomerParams{
		Description:      stripe.String("Stripeテストです"),
		Email:            stripe.String("d@test.com"),
		PreferredLocales: stripe.StringSlice([]string{"en", "es"}),
	}

	customer, ee := customer.New(paramCustomer)
	log.Printf(customer.ID)
	if ee != nil {
		log.Printf("pi.New: %v", ee)
		return
	}
	params := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(1800),
		Currency: stripe.String(string(stripe.CurrencyJPY)),
		AutomaticPaymentMethods: &stripe.PaymentIntentAutomaticPaymentMethodsParams{
			Enabled: stripe.Bool(true),
		},
	}
	pi, e := paymentintent.New(params)
	// log.Printf(pi.Customer.ID)
	if e != nil {
		log.Printf("pi.New: %v", e)
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"response": pi,
		"customer": customer,
	})
	// const secret_key = "sk_test_51MxRfkFYbsbXmSwa9ll8EQb5lo8aMN0ZuxUfCi4pvrhGmfKiXz8lI0FBin3qscADBLxvqgAEvfHiK1QOHbRLD1TN00kzxRvE4H"

}

// package main

// import (
//   "bytes"
//   "encoding/json"
//   "io"
//   "log"
//   "net/http"
//   "github.com/stripe/stripe-go/v74"
//   "github.com/stripe/stripe-go/v74/paymentintent"
// )

// func main() {
//   // This is your test secret API key.
//   stripe.Key = "sk_test_51MxRfkFYbsbXmSwa9ll8EQb5lo8aMN0ZuxUfCi4pvrhGmfKiXz8lI0FBin3qscADBLxvqgAEvfHiK1QOHbRLD1TN00kzxRvE4H"

//   fs := http.FileServer(http.Dir("public"))
//   http.Handle("/", fs)
//   http.HandleFunc("/create-payment-intent", handleCreatePaymentIntent)

//   addr := "localhost:4242"
//   log.Printf("Listening on %s ...", addr)
//   log.Fatal(http.ListenAndServe(addr, nil))
// }

// type item struct {
//   id string
// }

// func calculateOrderAmount(items []item) int64 {
// 	// Replace this constant with a calculation of the order's amount
// 	// Calculate the order total on the server to prevent
// 	// people from directly manipulating the amount on the client
// 	return 1800
// }

// func handleCreatePaymentIntent(w http.ResponseWriter, r *http.Request) {
// 	if r.Method != "POST" {
// 		http.Error(w, http.StatusText(http.StatusMethodNotAllowed), http.StatusMethodNotAllowed)
// 		return
// 	}

// 	var req struct {
// 		Items []item `json:"items"`
// 	}

// 	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		log.Printf("json.NewDecoder.Decode: %v", err)
// 		return
// 	}

// 	// Create a PaymentIntent with amount and currency
// 	params := &stripe.PaymentIntentParams{
// 		Amount:   stripe.Int64(calculateOrderAmount(req.Items)),
// 		Currency: stripe.String(string(stripe.CurrencyJPY)),
// 		AutomaticPaymentMethods: &stripe.PaymentIntentAutomaticPaymentMethodsParams{
// 			Enabled: stripe.Bool(true),
// 		},
// 	}

// 	pi, err := paymentintent.New(params)
// 	log.Printf("pi.New: %v", pi.ClientSecret)

// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		log.Printf("pi.New: %v", err)
// 		return
// 	}

// 	writeJSON(w, struct {
// 		ClientSecret string `json:"clientSecret"`
// 	}{
// 		ClientSecret: pi.ClientSecret,
// 	})
// }

// func writeJSON(w http.ResponseWriter, v interface{}) {
// 	var buf bytes.Buffer
// 	if err := json.NewEncoder(&buf).Encode(v); err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		log.Printf("json.NewEncoder.Encode: %v", err)
// 		return
// 	}
// 	w.Header().Set("Content-Type", "application/json")
// 	if _, err := io.Copy(w, &buf); err != nil {
// 		log.Printf("io.Copy: %v", err)
// 		return
// 	}
// }
