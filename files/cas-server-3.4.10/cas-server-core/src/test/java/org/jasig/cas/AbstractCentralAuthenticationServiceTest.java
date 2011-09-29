/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.ja-sig.org/products/cas/overview/license/
 */
package org.jasig.cas;

import org.jasig.cas.authentication.AuthenticationManager;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

/**
 * @author Scott Battaglia
 * @version $Revision: 19808 $ $Date: 2010-01-21 09:37:10 -0500 (Thu, 21 Jan 2010) $
 * @since 3.0
 */
@ContextConfiguration(locations={"/applicationContext.xml"})
public abstract class AbstractCentralAuthenticationServiceTest extends AbstractJUnit4SpringContextTests {

    @Autowired(required = true)
    private CentralAuthenticationService centralAuthenticationService;

    @Autowired(required=true)
    private TicketRegistry ticketRegistry;

    @Autowired(required=true)
    private AuthenticationManager authenticationManager;

    public AuthenticationManager getAuthenticationManager() {
        return this.authenticationManager;
    }

    public CentralAuthenticationService getCentralAuthenticationService() {
        return this.centralAuthenticationService;
    }

    public void setCentralAuthenticationService(final CentralAuthenticationService centralAuthenticationService) {
        this.centralAuthenticationService = centralAuthenticationService;
    }

    public TicketRegistry getTicketRegistry() {
        return this.ticketRegistry;
    }
}
