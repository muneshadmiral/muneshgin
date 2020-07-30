package service

import "github.com/muneshadmiral/muneshgin/entity"

// VideoService for video
type VideoService interface {
	Save(entity.Video) entity.Video
	FindAll() []entity.Video
}

// videoService struct
type videoService struct {
	videos []entity.Video
}

// New Method
func New() VideoService {
	return &videoService{
		videos: []entity.Video{},
	}
}

func (service *videoService) Save(video entity.Video) entity.Video {
	service.videos = append(service.videos, video)
	return video
}

func (service *videoService) FindAll() []entity.Video {
	return service.videos
}
