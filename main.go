package main

import (
	appd "appdynamics"
	"github.com/gin-gonic/gin"
	"github.com/muneshadmiral/muneshgin/controller"
	"github.com/muneshadmiral/muneshgin/service"
)

var (
	videoService    service.VideoService       = service.New()
	videoController controller.VideoController = controller.New(videoService)
)

func main() {
	// //Configure AppD
	// cfg := appd.Config{}

	// // Controller
	// cfg.Controller.Host = "turing2020071222040213.saas.appdynamics.com"
	// cfg.Controller.Port = 443
	// cfg.Controller.UseSSL = true
	// cfg.Controller.Account = "turing2020071222040213"
	// cfg.Controller.AccessKey = "ovz4a1b6qhy5"

	// // App Context
	// cfg.AppName = "ms-login"
	// cfg.TierName = ""
	// cfg.NodeName = ""

	// // misc
	// cfg.InitTimeoutMs = 1000

	// // init the SDK
	// if err := appd.InitSDK(&cfg); err != nil {
	// 	fmt.Printf("Error initializing the AppDynamics SDK\n")
	// } else {
	// 	fmt.Printf("Initialized AppDynamics SDK successfully\n")
	// }

	server := gin.Default()

	server.GET("/videos", func(ctx *gin.Context) {
		ctx.JSON(200, videoController.FindAll())
	})

	server.POST("/videos", func(ctx *gin.Context) {
		ctx.JSON(200, videoController.Save(ctx))
	})

	server.Run(":4000")

}
