package factory // nolint typecheck

import (
	"fmt"
	"net/url"

	"github.com/paul-carlton/go-utils/pkg/location"
	"github.com/paul-carlton/go-utils/pkg/location/memory"
)

const (
	id string = "location factory"
)

// SelectHandler returns the appropriate location
// handler that implements the scheme used in the URI.
// Currently only Vault handler is implemented but
// there can be others.
func SelectHandler(uri string) (location.Handler, error) {
	uriParts, err := url.Parse(uri)
	if err != nil {
		return nil, fmt.Errorf("%s %s: %s", uri, location.ErrorStringURIParseFail, err)
	}

	switch uriParts.Scheme {
	case memory.HandlerScheme:
		return memory.GetHandler()
	default:
		return nil, fmt.Errorf("%s: %s", location.ErrorNotImplemented, uriParts.Scheme)
	}
}
