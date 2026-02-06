package wireguard

import (
	"fmt"
)

// Config represents WireGuard configuration
type Config struct {
	PrivateKey string
	PublicKey  string
	ListenPort int
	Endpoint   string
}

// Interface represents a WireGuard interface
type Interface struct {
	Name   string
	Config Config
}

// NewInterface creates a new WireGuard interface
func NewInterface(name string, config Config) *Interface {
	return &Interface{
		Name:   name,
		Config: config,
	}
}

// Up brings the WireGuard interface up
func (i *Interface) Up() error {
	fmt.Printf("Bringing up WireGuard interface %s...\n", i.Name)
	// Implementation logic for WireGuard up would go here
	return nil
}

// Down brings the WireGuard interface down
func (i *Interface) Down() error {
	fmt.Printf("Bringing down WireGuard interface %s...\n", i.Name)
	// Implementation logic for WireGuard down would go here
	return nil
}
