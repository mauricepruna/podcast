package main

import (
	"bytes"
	"encoding/xml"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

type rss struct {
	XMLName      xml.Name `xml:"rss"`
	Version      string   `xml:"version,attr"`
	XmlnsItunes  string   `xml:"xmlns:itunes,attr"`
	XmlnsContent string   `xml:"xmlns:content,attr"`
	XmlnsGoogle  string   `xml:"xmlns:googleplay,attr"`
	Channel      channel
}

type itunesCategory struct {
	XMLName    xml.Name `xml:"itunes:category"`
	Text       string   `xml:"text,attr"`
	SubElement struct {
		Text string `xml:"text,attr"`
	} `xml:"itunes:category"`
}
type itunesOwner struct {
	XMLName     xml.Name `xml:"itunes:owner"`
	ItunesName  string   `xml:"itunes:name"`
	ItunesEmail string   `xml:"itunes:email"`
}

type enclosure struct {
	XMLName xml.Name `xml:"enclosure"`
	Url     string   `xml:"url,attr"`
	Type    string   `xml:"type,attr"`
	Length  string   `xml:"length,attr"`
}

type guid struct {
	XMLName     xml.Name `xml:"guid"`
	IsPermalink bool     `xml:"isPermaLink,attr"`
	Value       string   `xml:",chardata"`
}
type item struct {
	XMLName        xml.Name `xml:"item"`
	Title          string   `xml:"title"`
	Description    string   `xml:"description"`
	PubDate        string   `xml:"pubDate"`
	Enclosure      enclosure
	ItunesDuration string `xml:"itunes:duration"`
	ItunesExplicit bool   `xml:"itunes:explicit"`
	Guid           guid
}

type channel struct {
	XMLName      xml.Name `xml:"channel"`
	Title        string   `xml:"title"`
	Link         string   `xml:"link"`
	Language     string   `xml:"language"`
	CopyRight    string   `xml:"copyright"`
	ItunesAuthor string   `xml:"itunes:author"`
	Description  string   `xml:"description"`
	ItunesType   string   `xml:"itunes:type"`
	ItunesOwner  itunesOwner
	ItunesImage  struct {
		Href string `xml:"href,attr"`
	} `xml:"itunes:image"`
	ItunesCategory itunesCategory
	ItunesExplicit bool `xml:"itunes:explicit"`
	Item           []item
}

func storeOnS3(content string) (string, error) {

	bucketName := os.Getenv("bucket_name")
	fileName := "podcast.xml"
	svc := s3.New(session.New())

	input := &s3.PutObjectInput{
		Body:        aws.ReadSeekCloser(strings.NewReader(content)),
		Bucket:      aws.String(bucketName),
		Key:         aws.String(fileName),
		ACL:         aws.String("public-read"),
		ContentType: aws.String("application/xml"),
	}

	result, err := svc.PutObject(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				log.Printf("Error %s", aerr.Error())
				return "", aerr
			}
		}
		// Print the error, cast err to awserr.Error to get the Code and
		// Message from an error.
		log.Printf("Error %s", err.Error())
		return "", err

	}

	log.Printf("Result: %s", result)
	return *result.ETag, nil
}

func LambdaHandler() (string, error) {

	log.Println("Lambda started")

	rss := rss{Version: "2.0"}
	rss.XmlnsItunes = "http://www.itunes.com/dtds/podcast-1.0.dtd"
	rss.XmlnsContent = "http://purl.org/rss/1.0/modules/content/"
	rss.XmlnsGoogle = "http://www.google.com/schemas/play-podcasts/1.0"

	rss.Channel.Title = "TITULO"
	rss.Channel.Link = "ENLACE"
	rss.Channel.Language = "en-us"
	rss.Channel.CopyRight = "MIT"
	rss.Channel.ItunesAuthor = "Author"
	rss.Channel.Description = "Esta es la description"
	rss.Channel.ItunesType = "Serial"
	rss.Channel.ItunesOwner.ItunesName = "Yo"
	rss.Channel.ItunesOwner.ItunesEmail = "yo@gmail.com"
	rss.Channel.ItunesImage.Href = "https://applehosted.podcasts.apple.com/hiking_treks/artwork.png"
	rss.Channel.ItunesCategory.Text = "Sport"
	rss.Channel.ItunesCategory.SubElement.Text = "Wilderness"

	rss.Channel.Item = []item{
		item{
			Title:       "Title",
			Description: "Description",
			PubDate:     "12/01/1989",
			Enclosure: enclosure{
				Url:    "URL",
				Type:   "Type",
				Length: "12345",
			},
			ItunesDuration: "30:00",
			Guid:           guid{Value: "dzpodtop10"},
		},
		item{
			Title:       "Title2",
			Description: "Description",
			PubDate:     "12/01/1989",
			Enclosure: enclosure{
				Url:    "URL",
				Type:   "Type",
				Length: "12345",
			},
			ItunesDuration: "30:00",
			Guid:           guid{Value: "dzpodtop10"},
		},
	}

	w := &bytes.Buffer{}
	w.WriteString(xml.Header)
	enc := xml.NewEncoder(w)
	enc.Indent("  ", "    ")
	enc.Encode(rss)
	result, error := storeOnS3(w.String())

	if error != nil {
		return "", error
	}
	return result, nil
}

func main() {
	lambda.Start(LambdaHandler)
}
