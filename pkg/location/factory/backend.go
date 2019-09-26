
package factory

import (
	"fmt"
	"net/url"

	"github.com/paul-carlton/go-utils/pkg/core"
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
		return nil, core.RaiseError(id, core.ErrorUnknown, fmt.Sprintf("%s %s:", uri, location.ErrorStringURIParseFail), err)
	}

	switch uriParts.Scheme {
	case memory.HandlerScheme:
		return memory.GetHandler()
	default:
		return nil, core.MakeError(id, core.ErrorInvalidInput, fmt.Sprintf("%s %s:", core.CodeText(core.ErrorNotImplemented), uriParts.Scheme))
	}
}
