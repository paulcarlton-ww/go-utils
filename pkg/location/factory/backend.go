package factory

import (
	"fmt"
	"net/url"

	"github.com/paulcarlton-ww/go-utils/pkg/location"
	"github.com/paulcarlton-ww/go-utils/pkg/location/memory"
)

// SelectHandler returns the appropriate location.
// handler that implements the scheme used in the URI.
// Currently only Vault handler is implemented but
// there can be others.
func SelectHandler(uri string) (location.Handler, error) {
	uriParts, err := url.Parse(uri)
	if err != nil {
		return nil, fmt.Errorf("%s %s: %s", uri, location.ErrorStringURIParseFail, err) //nolint:goerr113 // ?
	}

	switch uriParts.Scheme {
	case memory.HandlerScheme:
		return memory.GetHandler()
	default:
		return nil, fmt.Errorf("%s: %s", location.ErrorNotImplemented, uriParts.Scheme) //nolint:goerr113 // ?
	}
}
