/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.ja-sig.org/products/cas/overview/license/
 */
package org.jasig.cas.adaptors.cas;

import javax.servlet.ServletRequest;

import org.jasig.cas.authentication.principal.Credentials;

/**
 * Credentials class that maps to the paramters required by the Legacy CAS
 * password handler.
 * 
 * @author Scott Battaglia
 * @version $Revision: 14064 $ $Date: 2007-06-10 09:17:55 -0400 (Sun, 10 Jun 2007) $
 * @since 3.0
 */
public final class LegacyCasTrustedCredentials implements Credentials {

    private static final long serialVersionUID = 3618701894071892024L;

    private ServletRequest servletRequest;

    /**
     * @return Returns the servletRequest.
     */
    public ServletRequest getServletRequest() {
        return this.servletRequest;
    }

    /**
     * @param servletRequest The servletRequest to set.
     */
    public void setServletRequest(final ServletRequest servletRequest) {
        this.servletRequest = servletRequest;
    }
}
