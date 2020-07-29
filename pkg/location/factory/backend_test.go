package factory // nolint:testpackage // Prefer test in package

import (
	"fmt"
	"strings"
	"testing"

	"github.com/paulcarlton-ww/go-utils/pkg/location"
)

const memoryHandler = "memory"

func TestSelectHandlerErrors(t *testing.T) {
	l, err := SelectHandler("memory://")
	if err != nil {
		t.Errorf("SelectHandler failed, %s", err)
	}

	if l.Scheme() != memoryHandler {
		t.Errorf("Got %s", l.Scheme())
	}

	_, err = SelectHandler("something://")
	if err == nil {
		t.Errorf("Expected error but got nil")
		return
	}

	// First run a generic compare
	expected := fmt.Errorf("%s: something", location.ErrorNotImplemented) //nolint:goerr113 // ?
	if !strings.Contains(err.Error(), expected.Error()) {
		t.Errorf("Expected %s but got %s", location.ErrorNotImplemented, err)
	}

	// Test if the returned error type is as expected
	if _, ok := err.(error); !ok {
		t.Errorf("Expected error Type core.Error but received error object didn't match this type")
		return
	}
}

func TestSelectHandlerSchemes(t *testing.T) {
	l, err := SelectHandler("memory://")
	if err != nil {
		t.Errorf("SelectHandler failed, %s", err)
	}

	if l.Scheme() != memoryHandler {
		t.Errorf("Expected: vault Got:%s", l.Scheme())
	}
}
